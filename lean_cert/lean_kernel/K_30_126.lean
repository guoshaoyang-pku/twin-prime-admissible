import Sound
import lean_certs.cert_30_126

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H30_gt_126_kernel : ¬ ∃ t : List Nat, admissible 30 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 30) (d := 126) (c := cert_30_126) (by decide)

import Sound
import lean_certs.cert_40_126

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H40_gt_126_kernel : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 40) (d := 126) (c := cert_40_126) (by decide)

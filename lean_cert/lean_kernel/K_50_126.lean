import Sound
import lean_certs.cert_50_126

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_126_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 126 := by
  exact certValidRoot_sound (k := 50) (d := 126) (c := cert_50_126) (by decide)

import Sound
import lean_certs.cert_50_242

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H50_gt_242_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 242 := by
  exact certValidRoot_sound (k := 50) (d := 242) (c := cert_50_242) (by decide)

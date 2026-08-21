import Sound
import lean_certs.cert_50_198

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H50_gt_198_kernel : ¬ ∃ t : List Nat, admissible 50 t = true ∧ diameter t ≤ 198 := by
  exact certValidRoot_sound (k := 50) (d := 198) (c := cert_50_198) (by decide)

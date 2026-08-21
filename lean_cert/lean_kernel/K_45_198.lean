import Sound
import lean_certs.cert_45_198

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H45_gt_198_kernel : ¬ ∃ t : List Nat, admissible 45 t = true ∧ diameter t ≤ 198 := by
  exact certValidRoot_sound (k := 45) (d := 198) (c := cert_45_198) (by decide)

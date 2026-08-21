import Sound
import lean_certs.cert_49_198

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H49_gt_198_kernel : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 198 := by
  exact certValidRoot_sound (k := 49) (d := 198) (c := cert_49_198) (by decide)

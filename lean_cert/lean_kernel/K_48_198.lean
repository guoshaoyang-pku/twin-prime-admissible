import Sound
import lean_certs.cert_48_198

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_198_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 198 := by
  exact certValidRoot_sound (k := 48) (d := 198) (c := cert_48_198) (by decide)

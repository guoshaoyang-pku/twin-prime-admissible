import Sound
import lean_certs.cert_44_198

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H44_gt_198_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 198 := by
  exact certValidRoot_sound (k := 44) (d := 198) (c := cert_44_198) (by decide)

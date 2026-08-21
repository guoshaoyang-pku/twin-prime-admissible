import Sound
import lean_certs.cert_44_188

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_188_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 188 := by
  exact certValidRoot_sound (k := 44) (d := 188) (c := cert_44_188) (by decide)

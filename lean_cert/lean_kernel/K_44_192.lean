import Sound
import lean_certs.cert_44_192

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H44_gt_192_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 192 := by
  exact certValidRoot_sound (k := 44) (d := 192) (c := cert_44_192) (by decide)

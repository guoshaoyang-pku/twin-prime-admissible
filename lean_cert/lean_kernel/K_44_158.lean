import Sound
import lean_certs.cert_44_158

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_158_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 158 := by
  exact certValidRoot_sound (k := 44) (d := 158) (c := cert_44_158) (by decide)

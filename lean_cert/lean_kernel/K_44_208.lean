import Sound
import lean_certs.cert_44_208

open CertVerify

set_option maxHeartbeats 20000000 in
theorem H44_gt_208_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 208 := by
  exact certValidRoot_sound (k := 44) (d := 208) (c := cert_44_208) (by decide)

import Sound
import lean_certs.cert_44_176

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_176_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 176 := by
  exact certValidRoot_sound (k := 44) (d := 176) (c := cert_44_176) (by decide)

import Sound
import lean_certs.cert_44_170

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H44_gt_170_kernel : ¬ ∃ t : List Nat, admissible 44 t = true ∧ diameter t ≤ 170 := by
  exact certValidRoot_sound (k := 44) (d := 170) (c := cert_44_170) (by decide)

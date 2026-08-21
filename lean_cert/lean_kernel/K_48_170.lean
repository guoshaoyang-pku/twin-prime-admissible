import Sound
import lean_certs.cert_48_170

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H48_gt_170_kernel : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 170 := by
  exact certValidRoot_sound (k := 48) (d := 170) (c := cert_48_170) (by decide)

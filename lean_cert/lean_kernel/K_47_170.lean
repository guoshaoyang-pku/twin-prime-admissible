import Sound
import lean_certs.cert_47_170

open CertVerify

set_option maxHeartbeats 4000000 in
theorem H47_gt_170_kernel : ¬ ∃ t : List Nat, admissible 47 t = true ∧ diameter t ≤ 170 := by
  exact certValidRoot_sound (k := 47) (d := 170) (c := cert_47_170) (by decide)

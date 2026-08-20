import Sound
import lean_certs.cert_33_68

open CertVerify

theorem H33_gt_68 : ¬ ∃ t : List Nat, admissible 33 t = true ∧ diameter t ≤ 68 := by
  exact certValidRoot_sound (k := 33) (d := 68) (c := cert_33_68) (by native_decide)

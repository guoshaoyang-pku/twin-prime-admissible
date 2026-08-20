import Sound
import lean_certs.cert_27_68

open CertVerify

theorem H27_gt_68 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 68 := by
  exact certValidRoot_sound (k := 27) (d := 68) (c := cert_27_68) (by native_decide)

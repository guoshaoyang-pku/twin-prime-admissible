import Sound
import lean_certs.cert_27_74

open CertVerify

theorem H27_gt_74 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 27) (d := 74) (c := cert_27_74) (by native_decide)

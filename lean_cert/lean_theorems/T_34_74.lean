import Sound
import lean_certs.cert_34_74

open CertVerify

theorem H34_gt_74 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 34) (d := 74) (c := cert_34_74) (by native_decide)

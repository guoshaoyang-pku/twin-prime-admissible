import Sound
import lean_certs.cert_19_74

open CertVerify

theorem H19_gt_74 : ¬ ∃ t : List Nat, admissible 19 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 19) (d := 74) (c := cert_19_74) (by native_decide)

import Sound
import lean_certs.cert_28_74

open CertVerify

theorem H28_gt_74 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 28) (d := 74) (c := cert_28_74) (by native_decide)

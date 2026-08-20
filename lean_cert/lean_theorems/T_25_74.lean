import Sound
import lean_certs.cert_25_74

open CertVerify

theorem H25_gt_74 : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 25) (d := 74) (c := cert_25_74) (by native_decide)

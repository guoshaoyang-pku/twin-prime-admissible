import Sound
import lean_certs.cert_24_74

open CertVerify

theorem H24_gt_74 : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 24) (d := 74) (c := cert_24_74) (by native_decide)

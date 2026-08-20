import Sound
import lean_certs.cert_37_74

open CertVerify

theorem H37_gt_74 : ¬ ∃ t : List Nat, admissible 37 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 37) (d := 74) (c := cert_37_74) (by native_decide)

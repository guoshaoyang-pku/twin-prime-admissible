import Sound
import lean_certs.cert_26_74

open CertVerify

theorem H26_gt_74 : ¬ ∃ t : List Nat, admissible 26 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 26) (d := 74) (c := cert_26_74) (by native_decide)

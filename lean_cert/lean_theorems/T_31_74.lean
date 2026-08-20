import Sound
import lean_certs.cert_31_74

open CertVerify

theorem H31_gt_74 : ¬ ∃ t : List Nat, admissible 31 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 31) (d := 74) (c := cert_31_74) (by native_decide)

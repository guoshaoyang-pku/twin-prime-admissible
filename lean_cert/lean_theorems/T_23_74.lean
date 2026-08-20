import Sound
import lean_certs.cert_23_74

open CertVerify

theorem H23_gt_74 : ¬ ∃ t : List Nat, admissible 23 t = true ∧ diameter t ≤ 74 := by
  exact certValidRoot_sound (k := 23) (d := 74) (c := cert_23_74) (by native_decide)

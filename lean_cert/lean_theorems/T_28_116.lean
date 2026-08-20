import Sound
import lean_certs.cert_28_116

open CertVerify

theorem H28_gt_116 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 116 := by
  exact certValidRoot_sound (k := 28) (d := 116) (c := cert_28_116) (by native_decide)

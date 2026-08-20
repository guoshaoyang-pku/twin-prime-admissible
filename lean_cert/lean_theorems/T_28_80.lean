import Sound
import lean_certs.cert_28_80

open CertVerify

theorem H28_gt_80 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 80 := by
  exact certValidRoot_sound (k := 28) (d := 80) (c := cert_28_80) (by native_decide)

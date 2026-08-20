import Sound
import lean_certs.cert_28_94

open CertVerify

theorem H28_gt_94 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 94 := by
  exact certValidRoot_sound (k := 28) (d := 94) (c := cert_28_94) (by native_decide)

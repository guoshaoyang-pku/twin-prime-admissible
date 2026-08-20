import Sound
import lean_certs.cert_28_58

open CertVerify

theorem H28_gt_58 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 58 := by
  exact certValidRoot_sound (k := 28) (d := 58) (c := cert_28_58) (by native_decide)

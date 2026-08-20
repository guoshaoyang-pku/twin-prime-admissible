import Sound
import lean_certs.cert_28_56

open CertVerify

theorem H28_gt_56 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 56 := by
  exact certValidRoot_sound (k := 28) (d := 56) (c := cert_28_56) (by native_decide)

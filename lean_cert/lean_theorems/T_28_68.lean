import Sound
import lean_certs.cert_28_68

open CertVerify

theorem H28_gt_68 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 68 := by
  exact certValidRoot_sound (k := 28) (d := 68) (c := cert_28_68) (by native_decide)

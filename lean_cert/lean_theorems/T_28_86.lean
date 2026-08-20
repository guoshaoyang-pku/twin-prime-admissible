import Sound
import lean_certs.cert_28_86

open CertVerify

theorem H28_gt_86 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 86 := by
  exact certValidRoot_sound (k := 28) (d := 86) (c := cert_28_86) (by native_decide)

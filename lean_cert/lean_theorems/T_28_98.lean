import Sound
import lean_certs.cert_28_98

open CertVerify

theorem H28_gt_98 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 98 := by
  exact certValidRoot_sound (k := 28) (d := 98) (c := cert_28_98) (by native_decide)

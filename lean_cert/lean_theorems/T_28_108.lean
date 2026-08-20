import Sound
import lean_certs.cert_28_108

open CertVerify

theorem H28_gt_108 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 108 := by
  exact certValidRoot_sound (k := 28) (d := 108) (c := cert_28_108) (by native_decide)

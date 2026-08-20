import Sound
import lean_certs.cert_28_90

open CertVerify

theorem H28_gt_90 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 90 := by
  exact certValidRoot_sound (k := 28) (d := 90) (c := cert_28_90) (by native_decide)

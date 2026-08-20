import Sound
import lean_certs.cert_28_96

open CertVerify

theorem H28_gt_96 : ¬ ∃ t : List Nat, admissible 28 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 28) (d := 96) (c := cert_28_96) (by native_decide)

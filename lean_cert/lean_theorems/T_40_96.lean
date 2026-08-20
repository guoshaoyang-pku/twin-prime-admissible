import Sound
import lean_certs.cert_40_96

open CertVerify

theorem H40_gt_96 : ¬ ∃ t : List Nat, admissible 40 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 40) (d := 96) (c := cert_40_96) (by native_decide)

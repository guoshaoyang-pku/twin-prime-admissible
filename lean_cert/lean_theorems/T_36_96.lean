import Sound
import lean_certs.cert_36_96

open CertVerify

theorem H36_gt_96 : ¬ ∃ t : List Nat, admissible 36 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 36) (d := 96) (c := cert_36_96) (by native_decide)

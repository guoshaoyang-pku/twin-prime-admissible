import Sound
import lean_certs.cert_34_96

open CertVerify

theorem H34_gt_96 : ¬ ∃ t : List Nat, admissible 34 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 34) (d := 96) (c := cert_34_96) (by native_decide)

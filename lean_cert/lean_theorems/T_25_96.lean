import Sound
import lean_certs.cert_25_96

open CertVerify

theorem H25_gt_96 : ¬ ∃ t : List Nat, admissible 25 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 25) (d := 96) (c := cert_25_96) (by native_decide)

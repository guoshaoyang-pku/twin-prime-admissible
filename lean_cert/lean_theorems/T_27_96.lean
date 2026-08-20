import Sound
import lean_certs.cert_27_96

open CertVerify

theorem H27_gt_96 : ¬ ∃ t : List Nat, admissible 27 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 27) (d := 96) (c := cert_27_96) (by native_decide)

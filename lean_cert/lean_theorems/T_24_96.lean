import Sound
import lean_certs.cert_24_96

open CertVerify

theorem H24_gt_96 : ¬ ∃ t : List Nat, admissible 24 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 24) (d := 96) (c := cert_24_96) (by native_decide)

import Sound
import lean_certs.cert_39_96

open CertVerify

theorem H39_gt_96 : ¬ ∃ t : List Nat, admissible 39 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 39) (d := 96) (c := cert_39_96) (by native_decide)

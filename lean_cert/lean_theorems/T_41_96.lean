import Sound
import lean_certs.cert_41_96

open CertVerify

theorem H41_gt_96 : ¬ ∃ t : List Nat, admissible 41 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 41) (d := 96) (c := cert_41_96) (by native_decide)

import Sound
import lean_certs.cert_48_96

open CertVerify

theorem H48_gt_96 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 96 := by
  exact certValidRoot_sound (k := 48) (d := 96) (c := cert_48_96) (by native_decide)

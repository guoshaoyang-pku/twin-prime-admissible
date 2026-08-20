import Sound
import lean_certs.cert_48_140

open CertVerify

theorem H48_gt_140 : ¬ ∃ t : List Nat, admissible 48 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 48) (d := 140) (c := cert_48_140) (by native_decide)

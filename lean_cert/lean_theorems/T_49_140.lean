import Sound
import lean_certs.cert_49_140

open CertVerify

theorem H49_gt_140 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 140 := by
  exact certValidRoot_sound (k := 49) (d := 140) (c := cert_49_140) (by native_decide)

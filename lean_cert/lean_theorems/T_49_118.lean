import Sound
import lean_certs.cert_49_118

open CertVerify

theorem H49_gt_118 : ¬ ∃ t : List Nat, admissible 49 t = true ∧ diameter t ≤ 118 := by
  exact certValidRoot_sound (k := 49) (d := 118) (c := cert_49_118) (by native_decide)

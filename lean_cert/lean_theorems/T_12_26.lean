import Sound
import lean_certs.cert_12_26

open CertVerify

theorem H12_gt_26 : ¬ ∃ t : List Nat, admissible 12 t = true ∧ diameter t ≤ 26 := by
  exact certValidRoot_sound (k := 12) (d := 26) (c := cert_12_26) (by native_decide)

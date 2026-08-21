import Sound
import lean_certs.cert_4_6

open CertVerify

theorem H4_gt_6 : ¬ ∃ t : List Nat, admissible 4 t = true ∧ diameter t ≤ 6 := by
  exact certValidRoot_sound (k := 4) (d := 6) (c := cert_4_6) (by native_decide)

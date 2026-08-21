import Sound
import lean_certs.cert_3_4

open CertVerify

theorem H3_gt_4 : ¬ ∃ t : List Nat, admissible 3 t = true ∧ diameter t ≤ 4 := by
  exact certValidRoot_sound (k := 3) (d := 4) (c := cert_3_4) (by native_decide)

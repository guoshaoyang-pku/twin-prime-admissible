import Sound
import lean_certs.cert_17_38

open CertVerify

theorem H17_gt_38 : ¬ ∃ t : List Nat, admissible 17 t = true ∧ diameter t ≤ 38 := by
  exact certValidRoot_sound (k := 17) (d := 38) (c := cert_17_38) (by native_decide)
